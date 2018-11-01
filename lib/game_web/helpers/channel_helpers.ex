defmodule GameWeb.ChannelHelpers do
  def translate_error({msg, opts}) do
    Gettext.dgettext(GameWeb.Gettext, "errors", msg, opts)
  end
end
