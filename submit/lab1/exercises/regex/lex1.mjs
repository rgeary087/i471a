export default {
  $Ignore: /\s+/,  //this will be ignored.
  INT: /\d+/,      //token with kind INT        
  CHAR: /./,       //single char: must be last;
                   // /./ is a regex which matches any char other than '\n'
};
