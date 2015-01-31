require File.join(File.dirname(__FILE__),'..','spec_helper.rb')
describe Dijklstra do 
  
  let(:path){File.join(File.dirname(__FILE__), "..",'test_datas_config.yml')}
  subject(:dijklstra){Dijklstra.new(path)}

  context 'implement dijklstra' do
    it "respond should be min path" do
      expect(dijklstra.implement).to eq("start:1,end:4,path:1->2->7->4,length:4")
    end
  end

end