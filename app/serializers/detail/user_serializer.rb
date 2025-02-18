module Detail
  class UserSerializer < ::UserSerializer
    attribute :pure_roles do
      object.pure_roles.map do |role|
        record_by_serializer(role, RoleSerializer)
      end
    end
  end
end
