class Informer
  def initialize(client, resync_period)

  end

  def start
    every(:second) do
      # list all items, start watching them
    end
  end

  def on_add(&handler)
  end

  def on_update(&handler)
  end

  def on_delete(&handler)
  end
end
