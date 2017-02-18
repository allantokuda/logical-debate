class Question < OpenStruct
  SUBSTITUTIONS = %i(select1 select2 select3 text1 text2 text3 text4 text5).freeze

  def type
    case name
    when /select/ then :select
    else :text
    end
  end
end
