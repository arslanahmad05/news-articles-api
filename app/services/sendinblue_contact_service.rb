require 'sib-api-v3-sdk'
class SendinblueContactService

  def initialize(user)
    @user = user
  end

  def call
    api_instance = SibApiV3Sdk::ContactsApi.new
    create_contact = SibApiV3Sdk::CreateContact.new
    create_contact = {
      'email': @user&.email,
      'listIds': [ @user&.id ]
    }

    begin
      result = api_instance.create_contact(create_contact)
      return result
    rescue SibApiV3Sdk::ApiError => e
      return "Exception when calling ContactsApi->create_contact: #{e}"
    end
  end

end
