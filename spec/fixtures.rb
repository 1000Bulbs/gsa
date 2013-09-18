module Fixtures
  def many_records
    read 'fixtures/feeds/15_records.txt'
  end

  def one_records
    read 'fixtures/feeds/1_records.txt'
  end

  def many_query
    read 'fixtures/queries/many.txt'
  end

  def one_query
    read 'fixtures/queries/single.txt'
  end

  def none_query
    read 'fixtures/queries/none.txt'
  end

  def many_results
    read 'fixtures/result_sets/many.txt'
  end

  def one_results
    read 'fixtures/result_sets/single.txt'
  end

  def many_facets
    read 'fixtures/facets/many.txt'
  end

  def one_facets
    read 'fixtures/facets/single.txt'
  end

  def many_facet_results
    read 'fixtures/result_sets/many_facets.txt'
  end

  def one_facet_results
    read 'fixtures/result_sets/single_facets.txt'
  end

  def many_uids
    read 'fixtures/uids/many.txt'
  end

  def one_uids
    read 'fixtures/uids/single.txt'
  end

  def success_text
    "Success"
  end

  def uid
    "id"
  end

  #######
  private
  #######

  def read(file_path)
    eval(File.read(file_path))
  end
end
