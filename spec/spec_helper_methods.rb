def decoded_json_response text = response.body
  ActiveSupport::JSON.decode text
end
