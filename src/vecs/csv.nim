import parsecsv
import strutils
from streams import newFileStream

proc loadCsv*[T](filename: string, col: string): seq[T] =
  var s = newFileStream(filename, fmRead)
  if s == nil:
    raise newException(IOError, "cannot open the file" & filename)

  var x: CsvParser
  x.open(s, filename)
  defer: x.close()
  x.readHeaderRow()
  let idx = find(x.headers, col)
  if idx == -1:
    raise newException(IOError, "cannot find column " & col & " in the file" & filename)
  while readRow(x):
    when T is byte: 
      result.add byte(parseUInt x.row[idx])
    elif T is float32:
      result.add parseFloat x.row[idx]
    if result.len mod 1_000_000 == 0: echo result.len

