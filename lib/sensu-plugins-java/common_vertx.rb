module CommonVertX
  def request
    RestClient::Request.execute(
      method: :get,
      url: config[:endpoint]
    )
  end
end
