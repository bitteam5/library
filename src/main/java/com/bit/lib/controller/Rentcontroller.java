package com.bit.lib.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.bit.lib.domain.Paging;
import com.bit.lib.dto.RentDTO;
import com.bit.lib.service.RentService;

@Controller
public class Rentcontroller {

	@Autowired
	private RentService rentService;
	
	@Autowired
	Paging paging;


	@RequestMapping(value = "rentHistory.do", method = RequestMethod.GET)
	public String getRentHistoryList(Model model, HttpSession session,
			@RequestParam(required = false, defaultValue = "1")int page,
			@RequestParam(required = false, defaultValue = "0")int range) {
		String id = (String) session.getAttribute("id");
		
		int listCnt = rentService.getRentHistoryListCnt(id);
		
		paging.pageInfo(page, range, listCnt);
		System.out.println(paging.toString());
		System.out.println(id);
		System.out.println(rentService.getRentHistoryList(id, paging.getStartList()));
		
		model.addAttribute("rentHistoryList", rentService.getRentHistoryList(id, paging.getStartList()));
		model.addAttribute("paging", paging);
		
		return "mypage/rentHistory/rentHistory";
	}

	@RequestMapping(value = "rentNow.do", method = RequestMethod.GET)
	public String selectRentNow(Model model, HttpSession session) {
		String id = (String) session.getAttribute("id");
		List<RentDTO> rentDtos = rentService.selectRentNow(id);
		
		model.addAttribute("selectRentNow", rentDtos);
		return "mypage/rentNow/rentNow";
	}

	@RequestMapping(value = "/rent.do", method = RequestMethod.POST)
	@ResponseBody
	public void bookRent(@RequestParam List<String> chknos, HttpSession session) {
		String id = (String) session.getAttribute("id");
		System.out.println(chknos + "///" + id);

		rentService.bookRent(chknos, id);
		System.out.println("Rent Ok");
		rentService.bookstUpdate(chknos);
		System.out.println("up Ok");
		rentService.reserveCancel(chknos);
		System.out.println("delete Ok");
		

	}

	@RequestMapping(value = "renew.do", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public void renew(@RequestParam List<String> count) {
		System.out.println(count + "//controller에서 count");
		rentService.renew(count);
	}

	@RequestMapping(value = "return.do", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public void bookReturn(@RequestParam List<String> count) {
		System.out.println(count + "//controller에서 count");
		rentService.bookReturn(count);
		rentService.updateReserveFin(count);
		
	}
}
