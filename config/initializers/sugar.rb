def returning(value)
  yield(value)
  value
end

AppStore::Entry