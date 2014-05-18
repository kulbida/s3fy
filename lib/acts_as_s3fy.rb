module S3fy
  def self.included(base)
    base.send :extend, ClassMethods
  end
 
  module ClassMethods
    def acts_as_s3fy(options = {})
      cattr_accessor :s3fy_original_path
      cattr_accessor :s3fy_s3_path
      self.s3fy_s3_path = options[:s3fy_s3_path]
      self.s3fy_original_path = options[:s3fy_original_path]
      send(:include, InstanceMethods)
    end
  end
 
  module InstanceMethods

    def files_for_store(raw_params=[])
      raw_params.select {|k,v| k =~ /#{AWS_CONFIG[:params_key]}\d*/}.collect{|k,v| v}
    end

    def has_multiple_files?(raw_params=nil)
      if raw_params.present?
        files_for_store(raw_params).size > 1
      else
        strored_files_to_arr && strored_files_to_arr.size > 1
      end
      false
    end

    def delete_stored_files(files)
      files.each do |file|
        S3 { S3fyCore.delete("#{file}") }
      end
    end

    def upload_all_files(files)
      files.each do |firle|
        S3 { S3fyCore.store(File.basename(file), open(file)) }
      end
    end

    def strored_files_to_str(stored_files_arr, base_name_only=false)
      if base_name_only
        stored_files_arr.collect { |v| File.basename(v)+'|' }.to_s
      else
        stored_files_arr.collect { |v| v+'|' }.to_s
      end
    end
    
    def has_attachments?
      read_attribute(self.s3fy_original_path.to_sym).present?
    end

    def strored_files_to_arr
      if arr = read_attribute(self.s3fy_original_path.to_sym)
        arr.split('|')
      else
        []
      end
    end
    
    alias :saved_files :strored_files_to_arr

    def store_files(raw_params)
      unless read_attribute(self.s3fy_s3_path.to_sym).to_s.blank?
        delete_stored_files(files_for_store(raw_params))
        write_attribute(self.s3fy_original_path.to_sym, '')
        write_attribute(self.s3fy_s3_path.to_sym, '')
        self.save
      end
      upload_all_files(files_for_store(raw_params))
      
      write_attribute(self.s3fy_original_path.to_sym, strored_files_to_str(files_for_store(raw_params)))
      write_attribute(self.s3fy_s3_path.to_sym, strored_files_to_str(files_for_store(raw_params), true))
      self.save
    end

    def find_file(file)
      S3 { S3fyCore.value("#{File.basename(file)}") }
    end

    private

    def S3
      AWS::S3::Base.establish_connection!(
        :access_key_id     => "#{AWS_CONFIG[:access_key_id]}",
        :secret_access_key => "#{AWS_CONFIG[:secret_access_key]}"
      )
      data = yield if block_given?
      AWS::S3::Base.disconnect
      data
    end
    
  end
  
  ActiveRecord::Base.send :include, S3fy
end