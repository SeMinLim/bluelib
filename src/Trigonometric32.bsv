package Trigonometric32;


import FloatingPoint::*;
import Float32::*;
import FIFO::*;
import Vector::*;


import "BDPI" function Bit#(32) bdpi_sin32(Bit#(32) data);
import "BDPI" function Bit#(32) bdpi_cos32(Bit#(32) data);
import "BDPI" function Bit#(32) bdpi_asin32(Bit#(32) data);
import "BDPI" function Bit#(32) bdpi_acos32(Bit#(32) data);


typedef 16 TrigonoLatency32;


interface TrigonoImportIfc;
	method Action enq(Bit#(32) data);
	method ActionValue#(Bit#(32)) get;
endinterface
interface TrigonoIfc;
	method Action enq(Bit#(32) data);
	method Action deq;
	method Bit#(32) first;
endinterface


import "BVI" trigono_sin32 = 
module mkTrigonoSinImport32#(Clock aclk, Reset arst) (TrigonoImportIfc);
	default_clock no_clock;
	default_reset no_reset;

	input_clock (aclk) = aclk;
	method m_axis_dout_tdata get enable(m_axis_dout_tready) ready(m_axis_dout_tvalid) clocked_by(aclk);

	method enq(s_axis_phase_tdata) enable(s_axis_phase_tvalid) ready(s_axis_phase_tready) clocked_by(aclk);

	schedule (
		get, enq
	) CF (
		get, enq
	);
endmodule

import "BVI" trigono_cos32 = 
module mkTrigonoCosImport32#(Clock aclk, Reset arst) (TrigonoImportIfc);
	default_clock no_clock;
	default_reset no_reset;

	input_clock (aclk) = aclk;
	method m_axis_dout_tdata get enable(m_axis_dout_tready) ready(m_axis_dout_tvalid) clocked_by(aclk);

	method enq(s_axis_phase_tdata) enable(s_axis_phase_tvalid) ready(s_axis_phase_tready) clocked_by(aclk);

	schedule (
		get, enq
	) CF (
		get, enq
	);
endmodule

import "BVI" trigono_asin32 = 
module mkTrigonoAsinImport32#(Clock aclk, Reset arst) (TrigonoImportIfc);
	default_clock no_clock;
	default_reset no_reset;

	input_clock (aclk) = aclk;
	method m_axis_dout_tdata get enable(m_axis_dout_tready) ready(m_axis_dout_tvalid) clocked_by(aclk);

	method enq(s_axis_phase_tdata) enable(s_axis_phase_tvalid) ready(s_axis_phase_tready) clocked_by(aclk);

	schedule (
		get, enq
	) CF (
		get, enq
	);
endmodule

import "BVI" trigono_acos32 = 
module mkTrigonoAcosImport32#(Clock aclk, Reset arst) (TrigonoImportIfc);
	default_clock no_clock;
	default_reset no_reset;

	input_clock (aclk) = aclk;
	method m_axis_dout_tdata get enable(m_axis_dout_tready) ready(m_axis_dout_tvalid) clocked_by(aclk);

	method enq(s_axis_phase_tdata) enable(s_axis_phase_tvalid) ready(s_axis_phase_tready) clocked_by(aclk);

	schedule (
		get, enq
	) CF (
		get, enq
	);
endmodule


module mkTrigonoSin32 (TrigonoIfc);
	Clock curClk <- exposeCurrentClock;
	Reset curRst <- exposeCurrentReset;

	FIFO#(Bit#(32)) outQ <- mkFIFO;

`ifdef BSIM
	Vector#(TrigonoLatency32, FIFO#(Bit#(32))) latencyQs <- replicateM(mkFIFO);
	for (Integer i = 0; i < valueOf(TrigonoLatency32) - 1; i = i + 1 ) begin
		rule relay;
			latencyQs[i].deq;
			latencyQs[i+1].enq(latencyQs[i].first);
		endrule
	end
	rule relayOut;
		Integer lastIdx = valueOf(TrigonoLatency32)-1;
		latencyQs[lastIdx].deq;
		outQ.enq(latencyQs[lastIdx].first);
	endrule
`else
	TrigonoImportIfc sin32 <- mkTrigonoSinImport32(curClk, curRst);
	rule getOut;
		let r <- sin32.get;
		outQ.enq(r);
	endrule
`endif

	method Action enq(Bit#(32) data);
`ifdef BSIM
	latencyQs[0].enq(bdpi_sin32(data));
`else
	sin32.enq(data);
`endif
	endmethod
	method Action deq;
		outQ.deq;
	endmethod
	method Bit#(32) first;
		return outQ.first;
	endmethod
endmodule

module mkTrigonoCos32 (TrigonoIfc);
	Clock curClk <- exposeCurrentClock;
	Reset curRst <- exposeCurrentReset;

	FIFO#(Bit#(32)) outQ <- mkFIFO;

`ifdef BSIM
	Vector#(TrigonoLatency32, FIFO#(Bit#(32))) latencyQs <- replicateM(mkFIFO);
	for (Integer i = 0; i < valueOf(TrigonoLatency32) - 1; i = i + 1 ) begin
		rule relay;
			latencyQs[i].deq;
			latencyQs[i+1].enq(latencyQs[i].first);
		endrule
	end
	rule relayOut;
		Integer lastIdx = valueOf(TrigonoLatency32)-1;
		latencyQs[lastIdx].deq;
		outQ.enq(latencyQs[lastIdx].first);
	endrule
`else
	TrigonoImportIfc cos32 <- mkTrigonoCosImport32(curClk, curRst);
	rule getOut;
		let r <- cos32.get;
		outQ.enq(r);
	endrule
`endif

	method Action enq(Bit#(32) data);
`ifdef BSIM
	latencyQs[0].enq(bdpi_cos32(data));
`else
	cos32.enq(data);
`endif
	endmethod
	method Action deq;
		outQ.deq;
	endmethod
	method Bit#(32) first;
		return outQ.first;
	endmethod
endmodule

module mkTrigonoAsin32 (TrigonoIfc);
	Clock curClk <- exposeCurrentClock;
	Reset curRst <- exposeCurrentReset;

	FIFO#(Bit#(32)) outQ <- mkFIFO;

`ifdef BSIM
	Vector#(TrigonoLatency32, FIFO#(Bit#(32))) latencyQs <- replicateM(mkFIFO);
	for (Integer i = 0; i < valueOf(TrigonoLatency32) - 1; i = i + 1 ) begin
		rule relay;
			latencyQs[i].deq;
			latencyQs[i+1].enq(latencyQs[i].first);
		endrule
	end
	rule relayOut;
		Integer lastIdx = valueOf(TrigonoLatency32)-1;
		latencyQs[lastIdx].deq;
		outQ.enq(latencyQs[lastIdx].first);
	endrule
`else
	TrigonoImportIfc asin32 <- mkTrigonoAsinImport32(curClk, curRst);
	rule getOut;
		let r <- asin32.get;
		outQ.enq(r);
	endrule
`endif

	method Action enq(Bit#(32) data);
`ifdef BSIM
	latencyQs[0].enq(bdpi_asin32(data));
`else
	asin32.enq(data);
`endif
	endmethod
	method Action deq;
		outQ.deq;
	endmethod
	method Bit#(32) first;
		return outQ.first;
	endmethod
endmodule

module mkTrigonoAcos32 (TrigonoIfc);
	Clock curClk <- exposeCurrentClock;
	Reset curRst <- exposeCurrentReset;

	FIFO#(Bit#(32)) outQ <- mkFIFO;

`ifdef BSIM
	Vector#(TrigonoLatency32, FIFO#(Bit#(32))) latencyQs <- replicateM(mkFIFO);
	for (Integer i = 0; i < valueOf(TrigonoLatency32) - 1; i = i + 1 ) begin
		rule relay;
			latencyQs[i].deq;
			latencyQs[i+1].enq(latencyQs[i].first);
		endrule
	end
	rule relayOut;
		Integer lastIdx = valueOf(TrigonoLatency32)-1;
		latencyQs[lastIdx].deq;
		outQ.enq(latencyQs[lastIdx].first);
	endrule
`else
	TrigonoImportIfc acos32 <- mkTrigonoAcosImport32(curClk, curRst);
	rule getOut;
		let r <- acos32.get;
		outQ.enq(r);
	endrule
`endif

	method Action enq(Bit#(32) data);
`ifdef BSIM
	latencyQs[0].enq(bdpi_acos32(data));
`else
	acos32.enq(data);
`endif
	endmethod
	method Action deq;
		outQ.deq;
	endmethod
	method Bit#(32) first;
		return outQ.first;
	endmethod
endmodule

endpackage: Trigonometric32
