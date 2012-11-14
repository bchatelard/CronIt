require 'active_support/time'


class CronIt
  def self._every
    @every || []
  end
  def self.every(time, opts = {})
    @every ||= []
    @every << [time, opts]
  end
  def self._run
    @run ||= []
    b = eval("#{self.to_s}.new")
    if !b.nil?
      @run.each do |r|
        eval("b.#{r}")
      end
    end
  end
  def self.run(func)
    @run ||= []
    @run << func
  end
end

