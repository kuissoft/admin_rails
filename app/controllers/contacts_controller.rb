class ContactsController < AuthenticatedController
  def index
    @contacts = Contact.all
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      flash[:notice] = "Contact was created."
      redirect_to contacts_path
    else
      render :new
    end
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(contact_params)
      flash[:notice] = "Contact was updated."
      redirect_to contacts_path
    else
      render :edit
    end
  end

  def destroy
    Contact.destroy(params[:id])
    flash[:notice] = "Contact was deleted."
    redirect_to contacts_path
  end

  private

  def contact_params
    params.require(:contact).permit!
  end
end
