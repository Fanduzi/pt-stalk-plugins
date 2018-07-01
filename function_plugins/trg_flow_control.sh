# triggers when wsrep_flow_control_sent increase more than THRESHOLD 
# rm $_trg_tmp_file where first start!!!

_trg_tmp_file=/tmp/trg_flow_control.tmp

trg_plugin() {
   first=0
   Pre_wsrep_flow_control_sent=0
   [ -f $_trg_tmp_file ] && {
    Pre_wsrep_flow_control_sent=$(grep wsrep_flow_control_sent $_trg_tmp_file|awk '{print $2}') 
   } || first=1
   mysql --login-path=Your_Login_Path -ss -BNe "SHOW GLOBAL STATUS like 'wsrep_flow_control_sent'" > $_trg_tmp_file
   [ $first -eq 1 ] && echo 0 && return
   wsrep_flow_control_sent=$(grep wsrep_flow_control_sent $_trg_tmp_file|awk '{print $2}') 
   echo $((wsrep_flow_control_sent - Pre_wsrep_flow_control_sent))
}
