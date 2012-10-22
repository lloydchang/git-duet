require 'git/duet'
require_relative 'author_mapper'
require_relative 'command_methods'

class Git::Duet::DuetCommand
  include Git::Duet::CommandMethods

  def initialize(alpha, omega)
    @alpha, @omega = alpha, omega
    @author_mapper = Git::Duet::AuthorMapper.new
  end

  def execute!
    set_alpha_as_git_config_user
    report_env_vars
    write_env_vars
  end

  private
  attr_accessor :alpha, :omega, :author_mapper

  def set_alpha_as_git_config_user
    exec_check("git config user.name '#{alpha_info[:name]}'")
    exec_check("git config user.email '#{alpha_info[:email]}'")
  end

  def var_map
    {
      'GIT_AUTHOR_NAME' => alpha_info[:name],
      'GIT_AUTHOR_EMAIL' => alpha_info[:email],
      'GIT_COMMITTER_NAME' => omega_info[:name],
      'GIT_COMMITTER_EMAIL' => omega_info[:email]
    }
  end

  def alpha_info
    alpha_omega_info[@alpha]
  end

  def omega_info
    alpha_omega_info[@omega]
  end

  def alpha_omega_info
    @alpha_omega_info ||= author_mapper.map(@alpha, @omega)
  end
end
