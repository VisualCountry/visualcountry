#TODO: Remove after profile refactor

module ProfileAttributesWarning
  ATTR_BLACKLIST = MigrateUserToProfile::ATTR_MAPPINGS.values.reject do |attr|
    [:id, :created_at, :updated_at].include? attr
  end

  ATTR_BLACKLIST.each do |attr|
    define_method(attr) do
      log("WARNING: '#{attr}' called on '#{self.class}'")
      log("At: #{caller.first}")
      super()
    end

    define_method("#{attr}=") do |value|
      log("WARNING: '#{attr}=' called on '#{self.class}'")
      log("At: #{caller.first}")
      super(value)
    end
  end

  def log(message)
    logger.info("#{message}".yellow)
  end

  def logger
    Logger.new(STDOUT)
  end
end
