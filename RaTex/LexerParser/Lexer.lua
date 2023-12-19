local find = string.find
local insert = table.insert
local sub = string.sub

local PREFIX = "^[%c%s]*"

local LETTERS = "%a+";
local NUMBER = "%d+%.?%d*";
local SPECIAL_CHARACTER = "[#&_{}~%$%%%^\\]";
local OPERATOR = "[%+%-%*/=><]";
local BRACKET = "[%(%)%[%]]";
local PUNCTUATION_MARKS = "[`!@%*|;:'\",%./%?]"
local WHITESPACES = "[\32\t\n]+"

local MATCHES = {
    { PREFIX .. LETTERS, "LETTER" };
    { PREFIX .. NUMBER, "NUMBER" };
    { PREFIX .. SPECIAL_CHARACTER, "SPECIAL_CHARACTER" };
    { PREFIX .. OPERATOR, "OPERATOR" };
    { PREFIX .. BRACKET, "BRACKET" };
    { PREFIX .. PUNCTUATION_MARKS, "PUNCTUATION_MARK" };
    { PREFIX .. WHITESPACES, "WHITESPACES" };
}

local PATTERNS, TOKENS = {}, {}
for i, m in MATCHES do
    PATTERNS[i] = m[1]
    TOKENS[i] = m[2]
end

local function Lexer(source: string, init: number)
    local _tokens = {}
    local _pos = init or 0
    local _size = #source
    -- local previousContent, previousToken = "", ""
    while _pos <= _size do
        local matched = false
        for _type, _pattern in PATTERNS do
            local start, finish = find(source, _pattern, _pos)
            if not start then
                continue
            end
            _pos = finish + 1
            matched = true
            local content = sub(source, start, finish) ;
            local rawToken = TOKENS[_type]
            local tokenizedTable = {
                token = rawToken;
                content = content;
                start = start;
                finish = finish;
            } print(rawToken, content, start, finish)
            insert(_tokens, tokenizedTable)
            -- previousContent = content
            -- previousToken = rawToken
        end
        if not matched then print "not matched"
            return
        end
    end
    return _tokens
end

return Lexer