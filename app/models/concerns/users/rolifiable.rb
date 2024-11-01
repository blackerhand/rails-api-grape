module Users
  module Rolifiable
    extend ActiveSupport::Concern

    included do
      rolify strict: true

      def pure_roles
        roles.pure_roles
      end

      def add_resource_role(role_name, resource)
        add_role(role_name)
        add_role(role_name, resource)
      end

      def remove_resource_role(role_name, resource)
        remove_role(role_name, resource)
        remove_role(role_name) unless roles.resource_roles.exists?(name: role_name)
      end

      def role_names
        @role_names ||= roles.pluck(:name).uniq.map(&:to_sym)
      end

      # 我教的课程
      def teach_courses
        find_course_by_role(GRAPE_API::TEACHER_ROLE_NAME)
      end

      # 我助教的课程
      def assistant_courses
        find_course_by_role(GRAPE_API::ASSISTANT_ROLE_NAME)
      end

      # 学习的课程
      def study_courses
        find_course_by_role(GRAPE_API::STUDENT_ROLE_NAME)
      end

      def find_course_by_role(role_name)
        # Course.with_role(role_name, self)
        course_ids = roles.where(name: role_name, resource_type: 'Course').pluck(:resource_id).uniq.sort
        Course.where(id: course_ids)
      end

      # 所有课程
      def all_courses
        Course.where(id: all_course_ids)
      end

      def all_course_ids
        @all_course_ids ||= roles.where(resource_type: 'Course').pluck(:resource_id).uniq.sort
      end

      def all_course_count
        all_course_ids.length
      end

      def in_course?(course)
        roles.resource_roles.where(resource: course).exists?
      end

      # 超级管理员
      def super_admin?
        role_names.include?(GRAPE_API::SUPER_ADMIN_ROLE_NAME)
      end

      # 管理员
      def admin?
        role_names.include?(GRAPE_API::ADMIN_ROLE_NAME)
      end

      def teacher?
        role_names.include?(GRAPE_API::TEACHER_ROLE_NAME)
      end

      def student?
        role_names.include?(GRAPE_API::STUDENT_ROLE_NAME)
      end

      def assistant?
        role_names.include?(GRAPE_API::ASSISTANT_ROLE_NAME)
      end

      # 超级管理员默认拥有所有权限，非超级管理员需要判断对于该资源是否有权限
      def resources?(resource_key)
        super_admin? || resource_keys.include?(resource_key)
      end

      def record_resources?(record, resource_key)
        super_admin? || record_resource_keys(record).include?(resource_key)
      end

      def can_access_student
        student?
      end

      def can_access_teacher
        teacher? || assistant?
      end

      def can_access_admin
        admin? || super_admin?
      end

      # 获取 pure role resources
      def resources
        @resources ||=
          if super_admin?
            Resource.all
          else
            Resource.joins(:acls).where(acls: { role_id: roles.pure_roles.ids })
          end.order(id: :asc)
      end

      def resource_keys
        @resource_keys ||= resources.pluck(:key).uniq
      end

      # resource roles
      def record_resources(record)
        return Resource.all if super_admin?

        base_role_ids = roles.where(resource: record).pluck(:base_role_id)
        return Resource.where(id: nil) if base_role_ids.blank?

        Resource.joins(:acls).where(acls: { role_id: base_role_ids })
      end

      def record_resource_keys(record)
        record_resources(record).pluck(:key).uniq
      end
    end
  end
end
