class CleanFileObjectsJob < ApplicationJob
  queue_as :default

  def perform
    FileObject.all.map do |file_object|
      next if file_object.fileable.present?

      file_object.destroy
    end
  end
end
