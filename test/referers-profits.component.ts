import { Component, OnDestroy, OnInit, ViewChild } from "@angular/core";
import { Router } from "@angular/router";
import { Subscription } from "rxjs";
import { UtilService } from "@services/util.service";
import { FormBuilder, FormGroup, Validators } from "@angular/forms";
import { MatSnackBar } from "@angular/material/snack-bar";
import { TreoSplashScreenService } from "@treo/services/splash-screen/splash-screen.service";
import { TreoAnimations } from "@treo/animations";
import "moment/locale/es";
import { ConstantService } from "@services/constant.service";
import { ReferersService } from "../referers.service";
import { Faq } from "@models/faq";
import {
  ApexAxisChartSeries,
  ApexChart,
  ApexFill,
  ApexTitleSubtitle,
  ApexTooltip,
  ApexYAxis,
  ChartComponent,
} from "ng-apexcharts";

type ApexXAxis = {
  type?: "category" | "datetime" | "numeric";
  categories?: any;
  labels?: {
    style?: {
      colors?: string | string[];
      fontSize?: string;
    };
  };
};

export type ChartOptions = {
  series: ApexAxisChartSeries;
  chart: ApexChart;
  xaxis: ApexXAxis;
  yaxis: ApexYAxis | ApexYAxis[];
  title: ApexTitleSubtitle;
  labels: string[];
  stroke: any; // ApexStroke;
  dataLabels: any; // ApexDataLabels;
  fill: ApexFill;
  tooltip: ApexTooltip;
};
@Component({
  selector: "app-referers-profits",
  templateUrl: "./referers-profits.component.html",
  styleUrls: ["./referers-profits.component.scss"],
  providers: [ReferersService],
  animations: TreoAnimations,
})
export class ReferersProfitsComponent implements OnInit, OnDestroy {
  @ViewChild("chart") chart: ChartComponent;
  public chartOptions: Partial<ChartOptions>;
  private subscription: Subscription = new Subscription();
  screenType: string;
  formAdd: FormGroup;
  loading: boolean = true;
  loadingSrv: boolean = false;
  access: boolean = false;
  profits: any;
  referent: string;
  month: number;
  months: string[];
  monthsProfits: number[];
  monthsSells: number[];

  constructor(
    private utilSrv: UtilService,
    private router: Router,
    private splash: TreoSplashScreenService,
    private srv: ReferersService,
    private snack: MatSnackBar,
    public formBuilder: FormBuilder
  ) {}

  canWrite() {
    let permissions = JSON.parse(localStorage.getItem("profile")).privilege;
    let access = permissions.filter((perm: string) => {
      return perm === ConstantService.PERM_REFERIDOS_LECTURA;
    });
    return access.length > 0;
  }

  ngOnInit(): void {
    let access = this.canWrite();
    this.referent = JSON.parse(localStorage.getItem("profile")).rut;
    if (!access) {
      this.router.navigate(["/admin/unauthorized"]);
    } else {
      this.access = access;
      this.subscription.add(
        this.utilSrv.screenType$.subscribe((screen) => {
          this.screenType = screen;
        })
      );
    }
    this.month = 3;
    this.changeChart(this.month);
  }

  private getAllProfits(months: number) {
    console.log(this.referent);
    this.subscription.add(
      this.srv.getProfits(this.referent, months).subscribe(
        (response) => {
          this.monthsProfits = [];
          this.months = [];
          this.monthsSells = [];
          response.forEach((period) => {
            this.months.push(period._id);
            this.monthsProfits.push(period.profits);
            this.monthsSells.push(period.sells);
          });

          this.updateChart();
          this.loadingSrv = false;
          this.loading = false;
        },
        (error) => {
          this.loadingSrv = false;
          this.snack.open(
            "Se ha producido un error al intentar obtener el total de comisiones: " +
              error,
            "X",
            { verticalPosition: "top", duration: ConstantService.snackDuration }
          );
        }
      )
    );
  }
  private getMonthProfits(year: number, month: number) {
    console.log(this.referent);
    this.subscription.add(
      this.srv.getMonthProfits(this.referent, year, month).subscribe(
        (response) => {
          this.profits = response;
          console.log(this.profits);
          this.loadingSrv = false;
          this.loading = false;
        },
        (error) => {
          this.loadingSrv = false;
          this.snack.open(
            "Se ha producido un error al intentar obtener el detalle mensual de comisiones: " +
              error,
            "X",
            { verticalPosition: "top", duration: ConstantService.snackDuration }
          );
        }
      )
    );
  }

  private updateChart() {
    this.splash.hide();
    this.chartOptions = {
      series: [
        {
          name: "Total Comisiones",
          type: "column",
          data: this.monthsProfits,
        },
        {
          name: "Total Ventas",
          type: "line",
          data: this.monthsSells,
        },
      ],
      chart: {
        height: 350,
        type: "line",
        events: {
          click: (event: any, chartContext: any, config: any) => {
            if (config.dataPointIndex > -1)
              this.getPeriodProfitDetails(config.dataPointIndex);
          },
        },
      },
      stroke: {
        width: [0, 4],
      },
      title: {
        text: "Últimos " + this.month + " meses",
      },
      dataLabels: {
        enabled: true,
        enabledOnSeries: [0, 1],
        formatter: function (val, opts) {
          if (val > 1000) {
            return "$" + val;
          } else {
            return val;
          }
        },
      },
      labels: this.months,
      xaxis: {
        type: "category",
      },
      yaxis: [
        {
          title: {
            text: "Comisiones",
          },
        },
        {
          opposite: true,
          title: {
            text: "Ventas",
          },
        },
      ],
    };
  }

  changeChart(period: number) {
    if (period == 3 || period == 6 || period == 12) {
      this.month = period;
      this.getAllProfits(this.month);
    }
  }

  private getPeriodProfitDetails(period: string) {
    var year, month : number;
    year = this.months[period].substring(0, 4);
    month = this.months[period].substring(5, 7);
    console.log(year);
    console.log(month);
    this.getMonthProfits(year, month);
  }

  ngOnDestroy() {
    if (this.subscription) this.subscription.unsubscribe();
  }
}
