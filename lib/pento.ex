defmodule Pento do
  @moduledoc """
  Pento keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def app_name do
    Application.get_env(:pento, :config)[:app_name]
  end

  def noreply_email_address do
    Application.get_env(:pento, :config)[:noreply_email]
  end
end
