is_hangle <- function(char) {
  grepl(pattern="^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]+$", x=char)
}
