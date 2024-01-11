module GRAPE_API
  JWT_EXP     = Settings.JWT_EXP.to_i
  JWT_REM_EXP = Settings.JWT_REM_EXP.to_i
  JWT_REFRESH = Settings.JWT_REFRESH.to_i

  # 后台角色
  SUPER_ADMIN_ROLE_NAME    = :SUPER_ADMIN # 超级管理员
  RAILS_SERVE_STATIC_FILES = true

  TYPE_LIMIT_LENGTH = 40

  SUPPORT_FILE_TYPES = %w[Files::Avatar
                          Files::ContentImg
                          Files::ContentVideo]

  # 正则不允许为空, 设置的时候请注意此字段, 设置 optional 无效
  EMAIL_REGEX  = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  MOBILE_REGEX = /\A1[3-9]\d{9}\z/
  PASSWD_REGEX = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}\z/i # 8 位 字母+数字
  LINK_REGEX   = /\A(http|https):\/\/[\S]+\z/i

  # 字符串
  MAX_TEXT_LENGTH   = 20000
  MAX_STRING_LENGTH = 100

  # 字母开头, 正则允许为空, 非空检验用 grape 校验, 设置 optional 有效
  EN_REGEX = /\A([a-zA-Z][a-zA-Z0-9_\-:]*)?\Z/

  MAX_INTEGER = BigDecimal(99999999)

  PER_PAGE   = 15
  SEARCH_PER = 10

  NOT_REQUIRE_LOGIN = %w[post_users_auth_sign_in post_users_auth_sign_up
                         post_users_auth_reset post_users_auth_send_mail
                         post_users_auth_sso post_users_auth_sso_f post_users_auth_logout
                         get_files_id]

  USER_TYPES = %w[Admin User]
end
