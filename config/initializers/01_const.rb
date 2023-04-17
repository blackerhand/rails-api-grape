module GRAPE_API
  JWT_EXP          = Settings.JWT_EXP.to_i
  JWT_REFRESH      = Settings.JWT_EXP.to_i / 2
  SUPER_ADMIN_NAME = :SUPER_ADMIN

  TYPE_LIMIT_LENGTH = 40

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  # 字符串
  REQUIRES_STRING_REGEX = /\A.{1,50}\Z/
  OPTIONAL_STRING_REGEX = /\A.{0,50}\Z/

  MAX_TEXT_LENGTH   = 20000
  MAX_STRING_LENGTH = 50

  # 字母开头
  REQUIRES_EN_REGEX = /\A[A-Za-z]\w+\Z/

  # 字母/数字
  REQUIRES_EN_1_REGEX = /\A\w+\Z/

  MAX_INTEGER = BigDecimal(99999999)

  PER_PAGE   = 15
  SEARCH_PER = 10

  USER_TYPES = %w[Admin User]

  NOT_REQUIRE_LOGIN = %w[post_users_sign_in post_users_sign_up
                        post_users_reset post_users_send_mail
                        post_users_sso post_users_sso_f post_users_logout
                        get_files_id]
end
