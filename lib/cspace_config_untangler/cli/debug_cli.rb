require_relative 'helpers'

module CspaceConfigUntangler
  module Cli
    class DebugCli < Thor
      include CCU::Cli::Helpers

      desc 'write_field_defs', 'Write file containing field definition data'
      option :rectype, desc: 'Comma separated list (no spaces) of record types to include. Defaults to all.', default: 'all', aliases: '-r'
      option :format, desc: 'Output format: csv or json', default: 'csv', aliases: '-f'
      option :output, desc: 'Path to output file', default: 'data/field_definitions.csv', aliases: '-o'
      def write_field_defs
        field_defs = []
        get_profiles.each {|profile|
          p = CCU::Profile.new(profile: profile)
          if options[:rectype] == 'all'
            rts = p.rectypes.map{ |rt| rt.name }
          else
            rts = options[:rectype].split(',').map{ |e| e.strip }  
          end
          p.field_defs.each{ |id, arr|
            arr.each{ |fd| field_defs << fd if rts.include?(fd.rectype) }
          }

        }
        unless field_defs.empty?
          case options[:format]
          when 'csv'
            CSV.open(options[:output], 'wb'){ |csv|
              csv << field_defs[0].csv_header
              field_defs.each{ |fd| csv << fd.to_csv }
            }
          when 'json'
            File.open(options[:output], 'w'){ |file|
              file.write(JSON.pretty_generate(field_defs.map{ |fd| fd.to_h }))
            }
          else
            puts 'Format must be csv or json'
          end
        end
      end

      desc 'write_form_fields', 'Write file containing form field data'
      option :rectype, desc: 'Comma separated list (no spaces) of record types to include. Defaults to all.', default: 'all', aliases: '-r'
      option :format, desc: 'Output format: csv or json', default: 'csv', aliases: '-f'
      option :output, desc: 'Path to output file', default: 'data/form_fields.csv', aliases: '-o'
      def write_form_fields
        form_fields = []
        get_profiles.each {|profile|
          p = CCU::Profile.new(profile: profile)
          if options[:rectype] == 'all'
            rts = p.rectypes.map{ |rt| rt.name }
          else
            rts = options[:rectype].split(',').map{ |e| e.strip }  
          end
          p.form_fields.each{ |ff| form_fields << ff if rts.include?(ff.rectype) }
        }

        unless form_fields.empty?
          case options[:format]
          when 'csv'
            CSV.open(options[:output], 'wb'){ |csv|
              csv << form_fields[0].csv_header
              form_fields.each{ |ff| csv << ff.to_csv }
            }
          when 'json'
            File.open(options[:output], 'w'){ |file|
              file.write(JSON.pretty_generate(form_fields.map{ |ff| ff.to_h }))
            }
          else
            puts 'Format must be csv or json'
          end
        end
      end
    end
  end
end
