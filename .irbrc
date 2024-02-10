# frozen_string_literal: true

require 'rainbow/refinement'

if defined? Rails
  using Rainbow

  env_prompt = if Rails.env.development?
                 Rails.env[0..2].green
               elsif Rails.env.production?
                 Rainbow(Rails.env.upcase).black.background(:red).bright.bold
               else
                 Rails.env.magenta
               end

  prompt = "[%n]#{env_prompt}(#{Rainbow('%m').yellow})"

  IRB.conf[:PROMPT] ||= {}
  IRB.conf[:PROMPT][:RAILS] = {
    PROMPT_I: "#{prompt}> ",
    PROMPT_S: "#{prompt}%l ",
    PROMPT_C: "#{prompt}? ",
    RETURN: "=> %s\n"
  }

  IRB.conf[:PROMPT_MODE] = :RAILS
end

IRB.conf[:USE_AUTOCOMPLETE] = ENV["IRB_USE_AUTOCOMPLETE"] == "true"
