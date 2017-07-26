defmodule Chevpr.UserCan do
  def can?(user, [h | t]) do
    if user.id == h.id, do: true, else: can?(user, t)
  end

  def can?(user, []), do: false
end
