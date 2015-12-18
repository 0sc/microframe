module Utils
  def invalid_args_test(obj, mtd)
    assert_raises(ArgumentError) { obj.send(mtd) }
    # rand(1..5).times do
    #   assert_raises(ArgumentError) { obj.send(mtd) } unless i == num
    # end
  end
end
