defmodule PentoWeb.UserRegistrationView do
  use PentoWeb, :view

  def role do
    Pento.Accounts.get_roles()
  end

  def status do
    Pento.Accounts.get_user_status()
  end
end
