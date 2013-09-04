module KalpeshExtensions
  def puts *args
    unless defined?(@log)
      @log = Logger.new(Rails.root.to_s + "/log/custom.log")
    end
    print "\n\n\n#{'*' * 25} #{Time.now.strftime("%d %b %H:%M:%:S %P")} #{'*' * 25}\n"
    @log.info "\n\n\n#{'*' * 25} #{Time.now.strftime("%d %b %H:%M:%:S %P")} #{'*' * 25}"
    if args.present?
      args.each do |arg|
        if arg.class.name == 'Array'
          arg.each do |a|
            print_it(a, true)
          end
        else
          print_it(arg)
        end
      end
    end
    print "\n#{'*' * 25} #{Time.now.strftime("%d %b %H:%M:%S %P")} #{'*' * 25} \n\n\n"
    @log.info "#{'*' * 25} #{Time.now.strftime("%d %b %H:%M:%S %P")} #{'*' * 25} \n\n\n"
  end

  def print_it(arg, insp=false)
    if insp
      print arg.inspect
      @log.info arg.inspect
    else
      print arg
      @log.info arg
    end
  end

end
include KalpeshExtensions
system `cat /dev/null > log/passenger.3000.log`
system `cat /dev/null > log/development.log`
system `cat /dev/null > log/production.log`
system `cat /dev/null > log/custom.log`
