# 通用接口
module Api::V1
  class StaticGrape < Api::PubGrape
    desc '获取枚举字段列表' do
      headers Authorization: {
        description: 'jwt token',
        required:    true
      }
      summary '获取枚举字段列表'
      detail 'get_enums'
      tags ['static']
      success({ code: 200, model: Entities::RecordBase, examples: {
        'resource.menu_type': [{ label: '菜单', value: 'menu' }, { label: '按钮', value: 'button' }]
      } })
    end
    params do
      auto_field :enum_fields, type: Array, desc: '枚举字段关键字, 例如 resource.menu_type'
    end
    get '/enums' do
      result = {}
      params.enum_fields.each do |enum_field|
        model_class, enum_key = tran_model_field(enum_field)
        enum_keys             = enum_key.to_s.pluralize

        result[enum_field] =
          if model_class.respond_to? "#{enum_key}_for_select"
            model_class.send("#{enum_key}_for_select").map do |field_en, field_zh|
              { label: field_zh, value: field_en }
            end
          elsif model_class.respond_to? enum_keys
            model_class.send(enum_keys)
          end
      end

      data! result
    end
  end
end
