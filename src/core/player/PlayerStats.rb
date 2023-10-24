class PlayerStats
  attr_accessor :intelligence
  attr_accessor :force
  attr_accessor :agilite
  attr_accessor :chance

  attr_accessor :health_point
  attr_accessor :max_health_point

  def initialize
    @intelligence = 0
    @force        = 0
    @agilite      = 0
    @chance       = 0
  end

  def get_stat(ability_identifier)
    self.instance_variable_get("@#{ability_identifier}")
  end

  def incr_stat(ability_identifier, value)
    if self.instance_variable_get("@#{ability_identifier}")
      self.instance_variable_set("@#{ability_identifier}",
                                 self.instance_variable_get("@#{ability_identifier}") + value)
    else
      raise("The value #{ability_identifier} doesn't exist in the player stats or isn't instanced")
    end
  end

  def set_stat(ability_identifier, value)
    if self.instance_variable_get("@#{ability_identifier}")
      self.instance_variable_set("@#{ability_identifier}", value)
    else
      raise("The value #{ability_identifier} doesn't exist in the player stats or isn't instanced")
    end
  end
end