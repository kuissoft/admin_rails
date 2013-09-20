class Api::V1::ContactsController < Api::V1::AuthenticatedController
  respond_to :json

  def index
    user = User.find(params[:user_id])
    render json: user.contacts
  end

  def create
    user = User.find(params[:user_id])
    contact = user.contacts.build(contact_params)
    if contact.save
      render json: contact
    else
      head 400
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:target_id)
  end
end
