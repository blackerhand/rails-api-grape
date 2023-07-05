# base for sign grapes
class SignGrape < BaseGrape
  helpers AuthHelper

  before { parse_jwt! }
end
