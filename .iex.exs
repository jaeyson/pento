import Ecto.{Changeset, Query}
import Logger

alias Pento.{Accounts, Catalog, Repo}
alias Pento.Accounts.{User, UserToken, UserNotifier}
alias Pento.Catalog.{Product}
alias PentoWeb.Router.Helpers, as: Routes
alias PentoWeb.Endpoint

IEx.configure(
  inspect: [
    limit: :infinity,
    printable_limit: :infinity
  ]
)

Logger.info("Most modules are aliased now, with ecto, routes and endpoint")
