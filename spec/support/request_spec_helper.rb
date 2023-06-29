module RequestSpecHelper
  def json
    Hashie::Mash.new JSON.parse(response.body)
  end
end
