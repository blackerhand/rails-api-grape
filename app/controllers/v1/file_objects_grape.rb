module V1
  class FileObjectsGrape < SignGrape
    desc '上传内容图片' do
      summary '上传内容图片'
      detail '上传内容图片'
      tags ['files']
    end
    params do
      requires :base64, type: String, allow_blank: false, desc: 'base64'
    end
    post '/content_img' do
      temp_file   = Uploads::Base64Service.execute(params.base64)
      content_img = Files::ContentImg.create!(file: temp_file)
      data_record!(content_img, Entities::FileObject)
    end

    route_param :id, requirements: { id: /[0-9]+/ } do
      desc '操作指南文件下载' do
        summary '操作指南文件下载'
        detail '操作指南文件下载'
        tags ['files']
      end
      get '/' do
        @file_object = FileObject.find(params.id)
        data_file_object! @file_object
      end
    end
  end
end
