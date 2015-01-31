require_relative 'boot'

class Main

  class << self
    # How to use:
    # give a path which is datas collection for all node and spacing 
    # call the agent method
    def test
      path = File.join(File.dirname(__FILE__), "config",'datas_config.yml')
      p dijklstra_agent(path)
    end
    
    private

    def dijklstra_agent(path)
      dij = Dijklstra.new(path)
      return 'File is not exist' unless dij
      dij.implement
    end

  end

end

Main.test