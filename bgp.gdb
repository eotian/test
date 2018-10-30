define get_bgp_list
  p (struct bgp_vr *)(bgp_lib_globals->vr_in_cxt->proto)
  p/x *(struct list *)(((struct bgp_vr *)(bgp_lib_globals->vr_in_cxt->proto))->bgp_list)
end

define print_rd_list
  set $vr = (struct bgp_vr *)$arg0
  set $list_head = $vr->rd_list->head
  set $list_next = 0

  if $list_head
        set $rd = (struct bgp_rd_node *)$list_head->data
        printf "[RD %p %u:%u VRF_ID %u]\n", $rd, $rd->rd.u.rd_as.rd_asnum, $rd->rd.u.rd_as.rd_asval,$rd->vrf_id
        printf "[RD RIB]:"
        p $rd->rib
        if $rd->vrf_id == 0
          #print_bgp_table $rd->rib
        end
        set $list_next = $list_head->next
  end

  while $list_next > 0
        set $rd = (struct bgp_rd_node *)$list_next->data
        #printf "[RD %p VRF_ID %u]\n", $rd, $rd->vrf_id
        printf "[RD %p %u:%u VRF_ID %u]\n", $rd, $rd->rd.u.rd_as.rd_asnum, $rd->rd.u.rd_as.rd_asval,$rd->vrf_id
        printf "[RD RIB]:"
        p $rd->rib
        if $rd->vrf_id == 0
            #print_bgp_table $rd->rib
        end
	set $list_next = $list_next->next
  end
end

define print_rt
  set $ecom = (struct ecommunity *)$arg0
  set $size = $ecom->size
  set $i = 0
  set $as = 0
  set $var = 0
  while $i < $size*8
    #if $ecom->val[$i] == 0
      set $as = ($ecom->val[$i+2] << 8)
      set $as = $as | ($ecom->val[$i+3])
      set $var = ($ecom->val[$i+4] << 24)
      set $var = $var | ($ecom->val[$i+5] << 16)
      set $var = $var | ($ecom->val[$i+6] << 8)
      set $var = $var | $ecom->val[$i+7]
    #end
    printf "RT %u:%u\n", $as, $var
#    printf "RT type %u, value %x %x %x %x %u %u\n", $ecom->val[$i], $ecom->val[$i+2], $ecom->val[$i+3], \
#$ecom->val[$i+4], $ecom->val[$i+5], $ecom->val[$i+6], $ecom->val[$i+7]
    set $i = $i + 8
  end
end


define print_rfd_list
  set $vr = (struct bgp_vr *)$arg0
  set $rfd_hinfo = (struct bgp_rfd_hist_info *)$vr->rfd_non_reuse_list
  set $rfd_hinfo_next = 0

  if $rfd_hinfo
    #p *$rfd_hinfo
    print_prefix $rfd_hinfo->rfdh_rn
    set $rfd_hinfo_next = $rfd_hinfo->rfdh_reuse_next
  end

  while $rfd_hinfo_next > 0
    #p *$rfd_hinfo_next
    print_prefix $rfd_hinfo_next->rfdh_rn
    set $rfd_hinfo_next = $rfd_hinfo_next->rfdh_reuse_next
  end
end

define print_bgp_list
  set $list_head = (struct listnode*)$arg0
  set $list_next = 0

  if $list_head
        set $bgp = (struct bgp *)$list_head->data
        printf "[BGP INSTANCE VRF %u]: %p\n", $bgp->owning_ivrf->id, $bgp
        printf "[BGP RIB]:"
        p $bgp->rib
        set $list_next = $list_head->next
  end

  while $list_next > 0
        set $bgp = (struct bgp *)$list_next->data
        printf "[BGP INSTANCE VRF %u]: %p\n", $bgp->owning_ivrf->id, $bgp
        printf "[BGP RIB]:"
        p $bgp->rib
        set $list_next = $list_next->next
  end
end

define print_peer_list
  set $bgp = (struct bgp *)$arg0
  set $list_head = (struct listnode*)$bgp->peer_list->head
  set $list_next = 0

  if $list_head
     set $peer = (struct bgp_peer *)$list_head->data
     printf "[BGP peer %s AS %u stat %u]\n", $peer->host, $peer->as, $peer->bpf_state
     p $peer
     set $list_next = $list_head->next
  end

  while $list_next > 0
     set $peer = (struct bgp_peer *)$list_next->data
     p $peer
     printf "[BGP peer %s AS %u stat %u]\n", $peer->host, $peer->as, $peer->bpf_state
     set $list_next = $list_next->next
  end
end

define print_prefix
set $rn = (struct bgp_node *)$arg0
if $rn->tree->family == 2
  set $family = $rn->key[0]
  set $len = $rn->key_len - 8
  if $family == 2
      set $p1 = $rn->key[1] 
      set $p2 = $rn->key[2]
      set $p3 = $rn->key[3] 
      set $p4 = $rn->key[4]
  else
      set $p1 = $rn->key[1]
      set $p2 = $rn->key[2]
      set $p3 = $rn->key[3]
      set $p4 = $rn->key[4]
      set $p5 = $rn->key[5]
      set $p6 = $rn->key[6]
      set $p7 = $rn->key[7]
      set $p8 = $rn->key[8]
      set $p9 = $rn->key[9]
      set $p10 = $rn->key[10]
      set $p11 = $rn->key[11]
      set $p12 = $rn->key[12]
      set $p13 = $rn->key[13]
      set $p14 = $rn->key[14]
      set $p15 = $rn->key[15]
      set $p16 = $rn->key[16]
  end
else
  if $rn->tree->family == 0
      set $family = 2
      set $p1 = $rn->key[0]
      set $p2 = $rn->key[1]
      set $p3 = $rn->key[2]
      set $p4 = $rn->key[3]
  else
      set $family = 10
      set $p1 = $rn->key[0]
      set $p2 = $rn->key[1]
      set $p3 = $rn->key[2]
      set $p4 = $rn->key[3]
      set $p5 = $rn->key[4]
      set $p6 = $rn->key[5]
      set $p7 = $rn->key[6]
      set $p8 = $rn->key[7]
      set $p9 = $rn->key[8]
      set $p10 = $rn->key[9]
      set $p11 = $rn->key[10]
      set $p12 = $rn->key[11]
      set $p13 = $rn->key[12]
      set $p14 = $rn->key[13]
      set $p15 = $rn->key[14]
      set $p16 = $rn->key[15]
  end
  set $len = $rn->key_len
end
if ($family == 2)
  printf "prefix %u.%u.%u.%u/%u, rn %p ftn_ix %u msg_id %u\n", $p1, $p2, $p3, $p4, $len, $rn, $rn->ftn_ix, $rn->msg_id
else
  printf "%02x%02x:%02x%02x:%02x%02x:%02x%02x:%02x02%x:%02x%02x:%02x%02x:%02x02%x/%u rn %p ftn_ix %u msg_id %u\n", \
$p1,$p2,$p3,$p4,$p5,$p6,$p7,$p8,$p9,$p10,$p11,$p12,$p13,$p14,$p15,$p16,$len, $rn, $rn->ftn_ix, $rn->msg_id
end
print_info $rn
end

define print_info
set $rn = (struct bgp_node *)$arg0
set $ri = (struct bgp_info *)$rn->info
  if $ri
	printf "--> info %p, nh 0x%x, flags %u, vrf_flags %u mvpn safi %u peer %s\n", $ri, $ri->attr->mp_nexthop_global_in.s_addr,\
	$ri->flags, $ri->vrf_flags, $ri->mvpn.safi, $ri->peer->host
	set $ri_next = $ri->next
  end
  while $ri_next
	printf "--> info %p, nh 0x%x, flags %u, vrf_flags %u mvpn safi %u peer %s\n", $ri_next, $ri_next->attr->mp_nexthop_global_in.s_addr,\
	$ri_next->flags, $ri_next->vrf_flags, $ri_next->mvpn.safi, $ri_next->peer->host
	set $ri_next = $ri_next->next
  end
end

define print_bgp_table
set $table = (struct bgp_ptree*)$arg0
set $rn = $table->top
printf "Begin..\n"
while $rn
set $ri = (struct bgp_info *)$rn->info
if $ri > 0
set $next = $ri->next
#p  $rn
print_prefix $rn
end

#if $ri > 0
#  if (($ri->flags & 2) > 0)
    #if (($ri->vrf_flags & 1) != 0)
#    if (($ri->vrf_flags & 1) == 0)
      #p  /x $ri->attr->mp_nexthop_global_in
      #p $ri
      #print_prefix $rn
      #printf " info %p nh 0x%x\n", $ri, $ri->attr->mp_nexthop_global_in.s_addr
#    end
#  end

#end
#if $next > 0
#  if (($next->flags & 2) > 0)
    #if (($next->vrf_flags & 1) != 0)
#    if (($next->vrf_flags & 1) == 0)
      #p  /x $next->attr->mp_nexthop_global_in
      #p $ri
      #print_prefix $rn
      #printf " info %p nh 0x%x\n", $next, $next->attr->mp_nexthop_global_in.s_addr
#    end
#  end
#end

if $rn->link[0]
   set $rn=$rn->link[0]
   loop_continue
end

if $rn->link[1]
   set $rn=$rn->link[1]
   loop_continue
end

while $rn->parent 
    if $rn->parent->link[0]== $rn && $rn->parent->link[1]
        set $rn = $rn->parent->link[1]
        loop_break
    end
    set $rn = $rn->parent
end

if ! $rn->parent
printf "End..\n"
loop_break
end

end
end
