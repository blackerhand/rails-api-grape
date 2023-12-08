class SignError < StandardError; end

class PermissionDeniedError < StandardError; end

class RecordStateError < StandardError; end

class RecordAlreadyDisabled < StandardError; end

class RecordNotAllowDisabled < StandardError; end

class SearchError < StandardError; end

class ClientRequestError < StandardError; end

class GetIoFormatError < StandardError; end

class WxaError < StandardError; end

# service 前置校验不通过
class ServiceCheckError < StandardError; end

class WxaPayError < StandardError; end

class RemoteFileGetError < StandardError; end
