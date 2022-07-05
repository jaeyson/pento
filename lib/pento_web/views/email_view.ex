defmodule PentoWeb.EmailView do
  use PentoWeb, :view

  def app_name do
    Application.get_env(:pento, :config)[:app_name]
  end
end
