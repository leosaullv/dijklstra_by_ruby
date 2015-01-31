require 'yaml'
class Dijklstra

  def initialize(path)
    return false unless File.exist?(path)
    config = YAML.load_file(path) 
    @datas = config['datas'].freeze
    @end = config['end']
    @start = config['start']
    @main_src = [[@start],0]                               # main path
    @possible_src = []                                     # possible path 
    @r_node = @datas.keys.delete_if{|x| x == @start}       # remainning collection on keys which removed be used key
  end

  def implement
    while key != @end
      begin
        min_src
      rescue Exception => e
        return 'Data is not complete! key:' + key
      end
    end
    str = 'start:' + @start.to_s + ',end:' + @end + ","
    str + 'path:' + @main_src[0].join('->') + ',length:' + @main_src[1].to_s
  end

  private
  
  #calculate min path
  # 3 cases
  # First : possible paths have a path which lower to main path
  # Second : possible paths hava a path which already include the end node
  # Third : Not the above two cases,the main path is lowest
  def min_src

    add_src
    key_re = reverse_key
    @r_node = @r_node.delete_if{|x| x == key}
    @possible_src.clone.each do |x|
      if x[0].last == main_src_key.last and x[1] < main_src_val
        @main_src = [x[0].clone,x[1]]
      elsif x[0].last == @end
        @main_src = @possible_src.select{|x| x[0].last == @end}.sort{|x,y| x[1] <=> y[1]}.first
      else
        key_re.each do |y|
          if y[0] == x[0].last and y[1] + x[1] < main_src_val
            @main_src = [(x[0] + [key]),y[1] + x[1]]
          end
        end
      end
    end
  end
  
  # update main path and possible path
  def add_src
    possible = sub_data.delete_if{|x| x == bet_min_key}
    possible.each do |x,v|
      unless main_src_key.include?(x)
        @possible_src << [main_src_key + [x], main_src_val + v] 
      end
    end
    @main_src[1] += bet_min
    @main_src[0] << bet_min_key
  end

  # current key
  def key
    main_src_key.last
  end
  
  #  As key to value,looking for it key,which for link to the possible path.
  def reverse_key
    re_key = []
    @datas.clone.each do |x,v|
      re_key << [x,v[key]] if v.has_key?(key)
    end
    re_key
  end
  
  # main path key
  def main_src_key
    @main_src.clone[0]
  end

  # main path value
  def main_src_val
    @main_src.clone[1]
  end

  # min value on key -> next key 
  # e.g.
  # eg = {"2"=>{"1"=>7, "3"=>10, "4"=>15},"3"=>{"1"=>9, "6"=>10, "4"=>11, "2"=>2}}
  # we have main path 2 -> 3 and current key is 3.
  # Then traversal the next collection in {"1"=>9, "6"=>10, "4"=>11, "2"=>2},the minist value is "2"=>2
  # but the key "2" is used. so we remove it and the minist is "1"=>9. The next key is "1" and the next min value is 9

  def bet_min
    sub_data.delete_if{|x| !@r_node.include?(x)}.values.min
  end

  # min key on key -> next key
  def bet_min_key
    @r_node.each do |x|
      return x  if sub_data.has_key?(x) and sub_data[x] == bet_min
    end
  end
  
  # get sub-datas list
  def sub_data
    @datas[key].clone
  end

end

