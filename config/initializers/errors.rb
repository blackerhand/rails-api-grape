class SignError < StandardError; end

class PermissionDeniedError < StandardError; end

class RecordStateError < StandardError; end

class RecordAlreadyDisabled < StandardError; end

class RecordNotAllowDisabled < StandardError; end

class RecordCheckInvalid < StandardError; end

class SearchError < StandardError; end

class ClientRequestError < StandardError; end

class GetIoFormatError < StandardError; end
