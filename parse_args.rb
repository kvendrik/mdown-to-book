=begin
Class that parses command line arguments

@author  Koen Vendrik <k.vendrik@gmail.com>
@date    November 2014
=end

=begin
Simple Usage:
require_relative 'parse_args'

parser = ParseArgs.new

parser.addReqArg('path')
parser.addOptArg('compose', short:'c')

args = argParser.parse(ARGV)
=end

class ParseArgs

    def initialize()
        @registered_arguments = {
            :required => [],
            :optional => []
        }
        @args = {}
        @required_arg_count = 0
    end

    def parse(arguments_arr)
        arguments_arr.each do |arg|
            # full optional args
            if /[\-]{2}[^\-]+/.match(arg)
                parts = arg.split('=')
                key = parts[0]
                val = parts[1]

                checkOptArgsForArg(key, val)
            # short optional args
            elsif /[\-][^\-]/.match(arg)
                checkOptArgsForArg(arg)
            # required args
            else
                checkReqArgsForIdx(@required_arg_count, arg)
                @required_arg_count += 1
            end
        end
        checkReqArgs()

        # make all arguments available
        # with arg name => value
        @registered_arguments.each do |key, args|
            args.each do |details|
                @args[details[:name]] = details[:value]
            end
        end

        return @args
    end

    def addReqArg(name, default_value: nil, help: nil)
        @registered_arguments[:required].push({ :name => name, :value => default_value, :help => help })
    end

    def addOptArg(name, short: nil, default_value: nil, action: 'store_true', help: nil)
        if short; short = '-'+short end
        @registered_arguments[:optional].push({ :name => '--'+name, :short => short, :value => default_value, :action => action, :help => help })
    end


private

    def checkReqArgs()
        # check if every required argument has a value
        if @registered_arguments[:required].length > @required_arg_count
            raise '`'+@registered_arguments[:required][@required_arg_count][:name]+'` is a required argument'
        end
    end

    def checkReqArgsForIdx(idx, val)
        # if current index in in array
        # insert value
        if @registered_arguments[:required][0]
            arg_details = @registered_arguments[:required][idx]
            if arg_details
                arg_details[:value] = val
            end
        end
    end

    def checkOptArgsForArg(arg, val=nil)

        def checkAction(arg_details, val_to_insert)
            # check what to do with value
            if arg_details[:action] == 'store_val'
                arg_details[:value] = val_to_insert
            else
                arg_details[:value] = true
            end
        end

        # loop optional args
        @registered_arguments[:optional].each do |arg_details|
            # check if name = arg
            if arg_details[:short] and arg_details[:short] == arg
                checkAction(arg_details, val)
            elsif arg_details[:name] == arg
                checkAction(arg_details, val)
            end
        end
    end

end