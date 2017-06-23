defmodule SlugTest do
  use ExUnit.Case
  doctest Slug

  @alphanumerics Enum.into(?A..?Z, []) ++
                 Enum.into(?a..?z, []) ++
                 Enum.into(?0..?9, [])
                 |> List.to_string()

  test "alphanumeric characters to lowercase" do
    assert Slug.slugify(@alphanumerics) == String.downcase(@alphanumerics)
  end

  test "returns nil if input cannot be slugified" do
    assert Slug.slugify("🙅‍") == nil
  end

  test "non-alphanumeric ASCII characters are stripped" do
    input =
      Enum.into(?!..?/, []) ++
      Enum.into(?:..?@, []) ++
      Enum.into(?[..?`, []) ++
      Enum.into(?{..?~, [])
      |> List.to_string()

    assert Slug.slugify(input) == nil
  end

  test "alphanumeric characters stay uppercase" do
    assert Slug.slugify(@alphanumerics, lowercase: false) == @alphanumerics
  end

  test "replace whitespaces and delimiters with a single separator" do
    assert Slug.slugify("Hello, World!") == "hello-world"
    assert Slug.slugify("  Hello,\t World!\n") == "hello-world"
  end

  test "customize separator with any codepoint or string" do
    assert Slug.slugify("Hello, World!", separator: ?_) == "hello_world"
    assert Slug.slugify("Hello, World!", separator: "") == "helloworld"
    assert Slug.slugify("Hello, World!", separator: "%20") == "hello%20world"
  end

  test "ignore certain characters" do
    assert Slug.slugify("你好，世界", ignore: ["好", "界"]) == "ni好shi界"
    assert Slug.slugify("你好，世界", ignore: "好界") == "ni好shi界"
  end

  test "truncate to nearest separator" do
    assert Slug.slugify("It's a small world", truncate: -1) == nil
    assert Slug.slugify("It's a small world", truncate: 0) == nil
    assert Slug.slugify("It's a small world", truncate: 2) == nil
    assert Slug.slugify("It's a small world", truncate: 5) == "its-a"
    assert Slug.slugify("It's a small world", truncate: 7) == "its-a"
    assert Slug.slugify("It's a small world", truncate: 20) == "its-a-small-world"
  end

  test "arabic letters" do
    assert Slug.slugify("مرحبا بالعالم") == "mrhb-blaalm"
  end

  test "amharic letters" do
    assert Slug.slugify("ሰላም ልዑል") == "salaame-leule"
  end

  test "armenian letters" do
    assert Slug.slugify("Բարեւ աշխարհ") == "barew-ashkharh"
  end

  test "bengali letters" do
    assert Slug.slugify("ওহে বিশ্ব") == "ohe-bishb"
  end

  test "burmese letters" do
    assert Slug.slugify("မင်္ဂလာပါကမ္ဘာလောက") == "mngglaapkmbhaaleaak"
  end

  test "chinese characters" do
    assert Slug.slugify("你好，世界") == "nihaoshijie"
  end

  test "gujarati letters" do
    assert Slug.slugify("હેલો, વિશ્વ") == "helo-vishv"
  end

  test "greek letters" do
    assert Slug.slugify("Γεια σας, τον κόσμο") == "geia-sas-ton-kosmo"
  end

  test "hebrew letters" do
    assert Slug.slugify("שלום, עולם") == "shlvm-vlm"
  end

  test "hindi letters" do
    assert Slug.slugify("नमस्ते दुनिया") == "nmste-duniyaa"
  end

  test "japanese characters" do
    assert Slug.slugify("こんにちは") == "konnitiha"
  end

  test "kannada letters" do
    assert Slug.slugify("ಹಲೋ, ಪ್ರಪಂಚ") == "hleuu-prpnc"
  end

  test "khmer letters" do
    assert Slug.slugify("សួស្តី​ពិភពលោក") == "suastiibibhblook"
  end

  test "korean characters" do
    assert Slug.slugify("안녕하세요, 세계") == "annyeonghaseyo-segye"
  end

  test "lao letters" do
    assert Slug.slugify("ສະ​ບາຍ​ດີ​ຊາວ​ໂລກ") == "sabaanydiisaawolk"
  end

  test "malayalam letters" do
    assert Slug.slugify("ഹലോ വേൾഡ്") == "hleeaa-veedd"
  end

  test "punjabi letters" do
    assert Slug.slugify("ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ ਦੁਨਿਆ") == "sti-srii-akaal-duniaa"
  end

  test "russian letters" do
    assert Slug.slugify("Привет мир") == "privet-mir"
  end

  test "sinhalese letters" do
    assert Slug.slugify("හෙලෝ වර්ල්ඩ්") == "heleaa-vrldd"
  end

  test "tamil letters" do
    assert Slug.slugify("வணக்கம், உலகம்") == "vnnkkm-ulkm"
  end

  test "telugu letters" do
    assert Slug.slugify("హలో, ప్రపంచం") == "hloo-prpncn"
  end

  test "thai letters" do
    assert Slug.slugify("สวัสดีชาวโลก") == "swasdiichaawolk"
  end

  test "vietnamese letters" do
    assert Slug.slugify("Chào thế giới") == "chao-the-gioi"
  end

  test "yiddish letters" do
    assert Slug.slugify("העלא וועלט") == "hl-vvlt"
  end
end
