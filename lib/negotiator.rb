class Negotiator
  VERSION = "0.1"

  def self.pick(h, o)
    r = parse(h)
    cand = []
    for s, q in o
      st = s.split(/\//)[0]
      case true
      when r[0].include?(s)
        q *= r[0][s]
      when r[1].include?(st)
        q *= r[1][st]
      else
        q *= r[2]
      end
      if q > 0
        cand << [s, q]
      end
    end

    if cand.empty?
      return nil
    end

    best = cand[0]
    for s, q in cand
      if q > best[1]
        best = [s, q]
      end
    end
    return best[0]
  end

  def self.parse(h)
    if !h
      h = "*/*"
    end

    qual = [{}, {}, 0.0]
    p = h.split(/,\s*/)
    for s in p
      t, st, q = parse_media_range(s)

      case true
      when t == "*"
        qual[2] = q
      when st == "*"
        qual[1][t] = q
      else
        qual[0]["#{t}/#{st}"] = q
      end
    end
    qual
  end

  def self.parse_media_range(s)
    q = 1.0
    if s[";"]
      s, qs = s.split(/;\s*/)
      if qs.index("q=") == 0
        q = Float(qs[2,qs.length])
      end
    end

    t, st = s.split(/\//)
    return t, st, q
  end
end
