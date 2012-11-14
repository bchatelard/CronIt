set :output, "#{Dir.pwd}/log/cron.log"

jobs = []

Dir["scripts/*.rb"].each do |file|
  file = "./#{file}"
  require file
  name = File.basename(file).split('.')[0].camelize
  every = eval(name + "._every")
  job_type name.to_sym, "cd :path &> /dev/null && ruby -r :task -e #{name}._run"
  jobs << {:name => name, :file => file, :every => every}
end


jobs.each do |script|
  script[:every].each do |e, opts|
    every e, opts do
      send script[:name].to_sym, script[:file]
    end
  end
end
