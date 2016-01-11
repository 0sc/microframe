module Utils
  def invalid_args_test(obj, mtd)
    assert_raises(ArgumentError) { obj.send(mtd) }
  end
end
