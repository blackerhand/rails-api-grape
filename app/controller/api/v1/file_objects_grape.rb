module Api::V1
  class FileObjectsGrape < Api::SignGrape
    desc '上传图片-base64' do
      summary '上传图片-base64'
      detail '上传图片-base64'
      tags ['files']
    end
    params do
      requires :base64, type: String, allow_blank: false, desc: 'base64'
      enum_field :file_type, values: GRAPE_API::SUPPORT_FILE_TYPES
    end
    post '/base64' do
      temp_file   = Uploads::Base64Service.execute(params.base64)
      file_type   = params.file_type.constantize
      file_record = file_type.create!(file: temp_file)
      data_records!(file_record, serializer: FileObjectSerializer)
    end

    desc '上传文件' do
      summary '上传文件'
      detail '上传文件'
      tags ['files']
    end
    params do
      file_field :file
      enum_field :file_type, values: GRAPE_API::SUPPORT_FILE_TYPES
    end
    post '/' do
      file_type = params.file_type.constantize
      params.file.filename.force_encoding("UTF-8")
      file = file_type.create!(file: params.file)
      data_records!(file, serializer: FileObjectSerializer)
    end

    route_param :id, requirements: { id: /[0-9]+/ } do
      desc '文件下载' do
        summary '文件下载'
        detail '文件下载'
        tags ['files']
      end
      get '/' do
        @file_object = FileObject.find(params.id)
        data_file_object! @file_object
      end
    end
  end
end
