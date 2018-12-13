class Config
  def self.[](name)
    ENV["AWS_PARAMETER_STORE_SECRETS_CONTROLLER_#{name.to_s.upcase}"]
  end

  def self.fetch(name, default)
    self[name] || default
  end
end
